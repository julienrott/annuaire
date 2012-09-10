# -*- coding: utf-8 -*-

from elixir import metadata
from annuaireapp import app
from annuaireapp.config import TestingConfig

app.config.from_object(TestingConfig)
metadata.bind = app.config['SQLALCHEMY_DATABASE_URI']
log = app.logger
app = app.test_client()

from manager import install
install()