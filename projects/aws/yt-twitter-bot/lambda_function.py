import feedparser
import os
import boto3

# SSM client
ssm = boto3.client('ssm')

PARAM_NAME = "last_video_id"

def get_last_video():
    try:
        response = ssm.get_parameter(Name=PARAM_NAME)
        return response['Parameter']['Value']
    except Exception as e:
        print("No previous video found:", str(e))
        return None

def save_last_video(video_id):
    ssm.put_parameter(
        Name=PARAM_NAME,
        Value=video_id,
        Type='String',
        Overwrite=True
    )

def lambda_handler(event, context):

    print("Lambda started")

    channel_id = os.environ.get("CHANNEL_ID")
    print("CHANNEL_ID:", channel_id)

    if not channel_id:
        raise Exception("CHANNEL_ID not set")

    feed_url = f"https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}"

    # ✅ Use feedparser directly (no requests)
    feed = feedparser.parse(feed_url)

    print("Feed length:", len(feed.entries))

    if not feed.entries:
        print("No videos found")
        return {"statusCode": 200}

    latest = feed.entries[0]

    title = latest.title
    video_id = latest.yt_videoid

    print("Latest Video:", title)
    print("Video ID:", video_id)

    # 🔥 SSM check
    last_video = get_last_video()

    if video_id == last_video:
        print("No new video")
        return {"statusCode": 200}

    print("New video found!")

    save_last_video(video_id)

    return {
        "statusCode": 200,
        "body": "Processed successfully"
    }