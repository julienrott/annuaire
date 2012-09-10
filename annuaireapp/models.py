# -*- coding: utf-8 -*-
import sqlalchemy

from annuaireapp import app

from elixir import Entity, Field
from elixir import Boolean, Date, DateTime, Integer, Unicode
from elixir import ManyToMany, ManyToOne
from elixir import using_options, using_options_defaults
from elixir import setup_all


class BaseEntity(Entity):
    using_options(abstract=True)
    using_options_defaults(shortnames=True)
    
    
class Person(BaseEntity):
    """
        Defines a person
    """
    firstname       = Field(Unicode(50), required=True)
    lastname        = Field(Unicode(50), required=True)
    birthdate       = Field(Date, required=True)
    teams           = ManyToMany('Team')
    localisation    = ManyToOne('Localisation', required=True)
    
    def to_dict(self):
        my_dict = {}
        my_dict['id']           = self.id
        my_dict['firstname']    = self.firstname
        my_dict['lastname']     = self.lastname
        my_dict['localisation'] = self.localisation.to_dict()

        return my_dict

class Team(BaseEntity):
    """
        Defines a team composed of persons
    """
    name            = Field(Unicode(50), required=True)
    leader          = ManyToOne('Person')
    persons         = ManyToMany('Person')

class Localisation(BaseEntity):
    """
        Defines a person localisation
    """    
    building        = Field(Unicode(50), required=True)
    floor           = Field(Integer)
    phone           = Field(Unicode(10))
    
    def to_dict(self):
        my_dict = {}
        my_dict['id']       = self.id
        my_dict['building'] = self.building
        my_dict['floor']    = self.floor
        my_dict['phone']    = self.phone

        return my_dict
    
setup_all()
    