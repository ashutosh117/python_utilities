#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
scrapping reddit for comments from Wikipedia,todayilearned
"""

import praw
reddit = praw.Reddit(user_agent = '',
                     client_id='',
                     client_secret = '',
                     username = '',
                     password = '')

l = []
subreddit_list = ['wikipedia','todayilearned']
for item in subreddit_list:
    subreddit = reddit.subreddit(item)
    hot_item = subreddit.hot(limit = None)
    for sub in hot_item:
        if not sub.stickied:
            l.append(sub.title)
            sub.comments.replace_more(limit = 0)
            for comment in sub.comments:
                l.append(comment.body)
                
f = open('wiki_reddit.txt','w')
f.write(' '.join(l).encode('utf8'))
f.close()
