#!/usr/bin/env python3

from setuptools import setup

setup(
    name="pub-sub-demo",
    version="1.0",
    description="",
    packages=["pub_sub_demo"],
    include_package_data=True,
    zip_safe=False,
    install_requires=[
        'flask',
        'gunicorn',
        'requests',
        'pyjwt[crypto]',
    ]
)
