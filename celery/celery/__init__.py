# -*- coding: utf-8 -*-
"""Distributed Task Queue"""
# :copyright: (c) 2009 - 2012 Ask Solem and individual contributors,
#                 All rights reserved.
# :copyright: (c) 2012 VMware, Inc., All rights reserved.
# :license:   BSD (3 Clause), see LICENSE for more details.

from __future__ import absolute_import

VERSION = (2, 6, 0, 'rc4')
__version__ = '.'.join(map(str, VERSION[0:3])) + ''.join(VERSION[3:])
__author__ = 'Ask Solem'
__contact__ = 'ask@celeryproject.org'
__homepage__ = 'http://celeryproject.org'
__docformat__ = 'restructuredtext'

# -eof meta-

# Lazy loading
from .__compat__ import recreate_module

old_module, new_module = recreate_module(__name__,  # pragma: no cover
    by_module={
        'celery.app':       ['Celery', 'bugreport'],
        'celery.app.task':  ['Task'],
        'celery.state':     ['current_app', 'current_task'],
        'celery.canvas':    ['chain', 'chord', 'chunks',
                             'group', 'subtask', 'xmap', 'xstarmap'],
        'celery.utils':     ['uuid'],
    },
    direct={'task': 'celery.task'},
    __package__='celery', __file__=__file__,
    __path__=__path__, __doc__=__doc__, __version__=__version__,
    __author__=__author__, __contact__=__contact__,
    __homepage__=__homepage__, __docformat__=__docformat__, VERSION=VERSION,
)
