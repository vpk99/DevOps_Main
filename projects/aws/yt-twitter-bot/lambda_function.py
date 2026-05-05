import os
import boto3
import requests

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

# 🔹 Save video ID
def save_last_video(video_id):
    ssm.put_parameter(
        Name=PARAM_NAME,
        Value=video_id,
        Type='String',
        Overwrite=True
    )

# 🔹 Fetch latest video using YouTube API
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

    print("YouTube API Status:", response.status_code)

    data = response.json()

    if "items" not in data or len(data["items"]) == 0:
        print("No videos found")
        return None, None

    video = data["items"][0]

    title = video["snippet"]["title"]
    video_id = video["id"].get("videoId")

    return title, video_id

# 🔹 Send email with approval links
def send_email(title, video_id):

    api_url = os.environ.get("API_URL")

    approve_link = f"{api_url}/approve?video_id={video_id}"
    reject_link  = f"{api_url}/reject?video_id={video_id}"

    body = f"""
Hi,

A new video has been uploaded.

Title: {title}
Watch: https://www.youtube.com/watch?v={video_id}

Approve: {approve_link}
Reject: {reject_link}
"""

    print("Sending email...")

    ses.send_email(
        Source=os.environ.get("EMAIL_FROM"),
        Destination={
            "ToAddresses": [os.environ.get("EMAIL_TO")]
        },
        Message={
            "Subject": {"Data": "YouTube Update: Approval Required"},
            "Body": {"Text": {"Data": body}}
        }
    )

    print("Email sent successfully")

# 🔥 MAIN HANDLER
def lambda_handler(event, context):

    print("Event:", event)

    # ===============================
    # 🔥 PART 1 — Handle API requests
    # ===============================
    raw_path = event.get("rawPath")
    params = event.get("queryStringParameters") or {}

    video_id = params.get("video_id")

    if raw_path == "/approve":
        print("Approved video:", video_id)
        return {
            "statusCode": 200,
            "body": "Approved!"
        }

    elif raw_path == "/reject":
        print("Rejected video:", video_id)
        return {
            "statusCode": 200,
            "body": "Rejected!"
        }

    # =====================================
    # 🔁 PART 2 — Normal scheduled execution
    # =====================================

    print("Lambda started")

    channel_id = os.environ.get("CHANNEL_ID")
    api_key = os.environ.get("YOUTUBE_API_KEY")

    if not channel_id or not api_key:
        raise Exception("CHANNEL_ID or API_KEY not set")

    title, video_id = get_latest_video(channel_id, api_key)

    if not video_id:
        return {"statusCode": 200}

    print("Latest Video:", title)
    print("Video ID:", video_id)

    last_video = get_last_video()

    if video_id == last_video:
        print("No new video")
        return {"statusCode": 200}

    print("New video found!")

    # Send approval email
    send_email(title, video_id)

    # Save video ID
    save_last_video(video_id)

    return {
        "statusCode": 200,
        "body": "Email sent for approval"
    }