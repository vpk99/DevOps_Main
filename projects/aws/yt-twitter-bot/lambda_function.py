import os
import boto3
import requests
from urllib.parse import quote

# AWS clients
ssm = boto3.client('ssm')
ses = boto3.client('ses')

PARAM_NAME = "last_video_id"

# 🔹 Get last video from SSM
def get_last_video():
    try:
        response = ssm.get_parameter(Name=PARAM_NAME)
        return response['Parameter']['Value']
    except:
        print("First run - no previous video")
        return None

# 🔹 Save latest video ID
def save_last_video(video_id):
    ssm.put_parameter(
        Name=PARAM_NAME,
        Value=video_id,
        Type='String',
        Overwrite=True
    )

# 🔹 Fetch latest video from YouTube API
def get_latest_video(channel_id, api_key):

    url = "https://www.googleapis.com/youtube/v3/search"

    params = {
        "key": api_key,
        "channelId": channel_id,
        "part": "snippet",
        "order": "date",
        "maxResults": 1
    }

    response = requests.get(url, params=params)

    print("YouTube Status:", response.status_code)
    print("YouTube Response:", response.text)

    if response.status_code != 200:
        return None, None

    data = response.json()

    if "items" not in data or len(data["items"]) == 0:
        return None, None

    video = data["items"][0]

    title = video["snippet"]["title"]
    video_id = video["id"].get("videoId")

    return title, video_id

# 🔥 Generate AI Caption using Gemini
def generate_ai_caption(title, video_id):

    api_key = os.environ.get("GEMINI_API_KEY")

    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={api_key}"

    prompt = f"""
Create an engaging social media caption for this YouTube video.

Requirements:
- Add emojis
- Add hashtags
- Keep it short and exciting
- Include call to action

Title: {title}

Video Link:
https://www.youtube.com/watch?v={video_id}
"""

    payload = {
        "contents": [
            {
                "parts": [
                    {
                        "text": prompt
                    }
                ]
            }
        ]
    }

    response = requests.post(url, json=payload)

    print("Gemini Status:", response.status_code)
    print("Gemini Response:", response.text)

    if response.status_code != 200:
        return f"{title}\nhttps://www.youtube.com/watch?v={video_id}"

    data = response.json()

    try:
        ai_text = data["candidates"][0]["content"]["parts"][0]["text"]
        return ai_text
    except:
        return f"{title}\nhttps://www.youtube.com/watch?v={video_id}"

# 🔹 Send Email
def send_email(title, video_id):

    api_url = os.environ.get("API_URL")
    token = os.environ.get("APPROVAL_TOKEN")

    # 🔥 Encode title for safe URL
    encoded_title = quote(title)

    # ✅ APPROVE LINK WITH TOKEN
    approve_link = f"{api_url}/approve?video_id={video_id}&title={encoded_title}&token={token}"

    # ✅ REJECT LINK
    reject_link = f"{api_url}/reject?video_id={video_id}&token={token}"

    body = f"""
New YouTube Video!

Title: {title}

Watch:
https://www.youtube.com/watch?v={video_id}

Approve:
{approve_link}

Reject:
{reject_link}
"""

    ses.send_email(
        Source=os.environ.get("EMAIL_FROM"),
        Destination={
            "ToAddresses": [os.environ.get("EMAIL_TO")]
        },
        Message={
            "Subject": {"Data": "YouTube Approval Required"},
            "Body": {"Text": {"Data": body}}
        }
    )

    print("Email sent successfully")

# 🔥 MAIN HANDLER
def lambda_handler(event, context):

    print("Event:", event)

    # ===================================
    # 🔐 Handle API Approve / Reject
    # ===================================
    raw_path = event.get("rawPath")
    params = event.get("queryStringParameters") or {}

    video_id = params.get("video_id")
    title = params.get("title")
    token = params.get("token")

    expected_token = os.environ.get("APPROVAL_TOKEN")

    if raw_path in ["/approve", "/reject"]:

        # 🔐 Validate token
        if token != expected_token:
            return {
                "statusCode": 403,
                "body": "Unauthorized"
            }

        # ✅ APPROVE
        if raw_path == "/approve":

            print("Approved:", video_id)

            ai_caption = generate_ai_caption(title, video_id)

            print("========== AI GENERATED CAPTION ==========")
            print(ai_caption)
            print("==========================================")

            return {
                "statusCode": 200,
                "body": ai_caption
            }

        # ❌ REJECT
        elif raw_path == "/reject":

            print("Rejected:", video_id)

            return {
                "statusCode": 200,
                "body": "Rejected!"
            }

    # ===================================
    # 🔁 Normal Scheduled Execution
    # ===================================

    print("Lambda started")

    channel_id = os.environ.get("CHANNEL_ID")
    api_key = os.environ.get("YOUTUBE_API_KEY")

    if not channel_id or not api_key:
        raise Exception("Missing CHANNEL_ID or YOUTUBE_API_KEY")

    title, video_id = get_latest_video(channel_id, api_key)

    if not video_id:
        return {"statusCode": 200}

    last_video = get_last_video()

    if video_id == last_video:
        print("No new video")
        return {"statusCode": 200}

    print("New video found!")

    send_email(title, video_id)

    save_last_video(video_id)

    return {
        "statusCode": 200,
        "body": "Approval email sent"
    }