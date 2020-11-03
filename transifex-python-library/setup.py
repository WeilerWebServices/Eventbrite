#!/usr/bin/env python

from setuptools import setup, find_packages


install_requires = []

setup(
    name="txlib",
    version="0.1.1+eventbrite",
    author="Indifex Ltd.",
    author_email="info@indifex.com",
    description="A python library for Transifex",
    url="http://www.indifex.com",

    packages=find_packages(),
    install_requires = install_requires,

    keywords = (
        'translation',
        'localization',
        'internationalization',
    ),
    license='LGPL3',
)
