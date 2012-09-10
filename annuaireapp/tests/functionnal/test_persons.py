# -*- coding: utf-8 -*-

import json

from datetime import date, datetime
from elixir import session

from annuaireapp.models import Person, Localisation, Team
from annuaireapp.tests import app, log
from annuaireapp.tests.functionnal import AnnuaireTest

class SearchPersonsTests(AnnuaireTest):
    """
        Retrieves persons with search param
        GET /persons?search=xxx
    """
    
    def setUp(self):
        """ Create default objects """
        
        theatre = Localisation(building=u"Théatre")
        stade_de_france = Localisation(building=u"Stade de France")
        hospital = Localisation(building=u"Hospital")
        
        Person(firstname=u"Christina", lastname=u"Aguilera", birthdate=date(1980, 4, 4), localisation=stade_de_france)
        Person(firstname=u"Christophe", lastname=u"Maé", birthdate=date(1960, 10, 6), localisation=hospital)
        Person(firstname=u"Matt", lastname=u"Pokora", birthdate=date(1981, 7, 4), localisation=hospital)
        Person(firstname=u"Cristiano", lastname=u"Ronaldo", birthdate=date(1975, 8, 7), localisation=theatre)
        Person(firstname=u"Jean-Pierre", lastname=u"Christian", birthdate=date(1975, 8, 7), localisation=theatre)
        
        session.commit()
    
    def tearDown(self):
        """ Remove default objects """
        Localisation.query.delete()
        Person.query.delete()
        
        session.commit()
    
    def test_getPersonsWithoutSearchParam_returns200(self):
        """ GET /persons without param returns 200 """
        response = self.get("/persons")
        
        assert response.status_code == 200
        data = self.parse(response.data)
        assert len(data['persons']) == 5
        assert data['persons'][0]['lastname'] == u'Aguilera'
        assert data['persons'][1]['lastname'] == u'Christian'
        assert data['persons'][2]['lastname'] == u'Maé'
        assert data['persons'][3]['lastname'] == u'Pokora'
        assert data['persons'][4]['lastname'] == u'Ronaldo'
    
    def test_getPersonsWithSearchParam_returns200(self):
        """ GET /persons?search=chris returns 200 """
        
        response = self.get("/persons?search=chris")
        
        assert response.status_code == 200
        data = self.parse(response.data)

        assert len(data['persons']) == 3
        assert data['persons'][0]['lastname'] == u'Aguilera'
        assert data['persons'][1]['lastname'] == u'Christian'
        assert data['persons'][2]['lastname'] == u'Maé'
    
    def test_getPersonsWithEmptySearchParam_returns400(self):
        """ GET /persons?search= returns 400 """

        response = self.get("/persons?search=")
        assert response.status_code == 400

        