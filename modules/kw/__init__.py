# ----------------------------------------
# - mode: python - 
# - author: helloplhm-qwq - 
# - name: __init__.py - 
# - project: lx-music-api-server - 
# - license: MIT - 
# ----------------------------------------
# This file is part of the "lx-music-api-server" project.

from common import Httpx
from common.exceptions import FailedException

tools = {
    'qualityMap': {
        '128k': '128kmp3',
        '320k': '320kmp3',
        'flac': '2000kflac',
    },
    'qualityMapReverse': {
        '128': '128k',
        '320': '320k',
        '2000': 'flac',
    },
    'extMap': {
        '128k': 'mp3',
        '320k': 'mp3',
        'flac': 'flac',
    }
}

async def url(songId, quality):
    target_url = f'''https://bd-api.kuwo.cn/api/service/music/downloadInfo/{songId}?isMv=0&format={tools['extMap'][quality]}&br={tools['qualityMap'][quality]}'''
    req = await Httpx.AsyncRequest(target_url, {
        'method': 'GET',
        'headers': {
            'User-Agent': 'okhttp/3.10.0',
            'channel': 'qq',
            'plat': 'ar',
            'net': 'wifi',
            'ver': '3.1.2',
            'uid': '',
            'devId': '0',
        }
    })
    try:
        body = req.json()
        data = body['data']

        if (body['code'] != 200) or (data['audioInfo']['bitrate'] == 1):
            raise FailedException('failed')

        return {
            'url': data['url'].split('?')[0],
            'quality': tools['qualityMapReverse'][data['audioInfo']['bitrate']]
        }
    except:
        raise FailedException('failed')