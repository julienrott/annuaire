# -*- coding: utf-8 -*-

import base64
import json

from annuaireapp.tests import app, log
from unittest import TestCase

class AnnuaireTest(TestCase):
    """ Defines a functionnal test in annuaire """
    
    def isStatusAndMessageCorrect(self, expectedStatus, expectedMessage, response):
        """ Check the status_code and the message of the response """
        return expectedStatus == response.status_code and expectedMessage in response.data
        

    def parse(self, responseData):
        """ Try to load JSON. Returns None if no JSON can be decoded """
        
        try:
            data = json.loads(responseData)
        except ValueError, e:
            log.debug('No JSON object could be decoded : %s', responseData)
            data = None
        
        return data
    
    def __open(self, url, method, user=None, data=None):
        
        params = dict()
        params['method'] = method
        
        if user != None :
            params['headers'] = {'Authorization': 'Basic ' + base64.b64encode(user['login'] + ':' + user['password'])}
        
        if data != None:
            params['data'] = data
        
        return app.open(url, **params)
                        
    def get(self, url, user=None):
        return self.__open(url, 'GET', user)
        
    def post(self, url, data, user=None):
        return self.__open(url, 'POST', user, data)
        
    def put(self, url, data, user=None):
        return self.__open(url, 'PUT', user, data)
        
    def delete(self, url, user=None):
        return self.__open(url, 'DELETE', user)
