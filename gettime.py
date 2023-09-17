#!/usr/bin/env python
# coding=utf-8
import datetime

date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
line = '%s,commit' % (date)
print(line)
