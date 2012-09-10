# -*- coding: utf-8 -*-

__all__ = ['DefaultConfig','TestingConfig']

class DefaultConfig(object):
    DEBUG = True
    TESTING = False
    SQLALCHEMY_DATABASE_URI = 'sqlite:///annuaire.s3db'
    
class TestingConfig(DefaultConfig):
    DEBUG = True
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'