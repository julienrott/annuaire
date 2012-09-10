# -*- coding: utf-8 -*-
import logging

from elixir import session
from flask import abort, Blueprint, jsonify, make_response, request

from annuaireapp import app
from annuaireapp.models import Person, Team

from sqlalchemy import or_

persons = Blueprint('persons', __name__)
person = Blueprint('person', __name__)

@persons.route('/<int:id>', methods=['GET'])
def get(id):
    p = Person()
    p = Person.query.get(id)

    response = make_response(jsonify(p.to_dict()))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@persons.route('', methods=['GET'])
def index():
    """ Get all persons with or without parameters
        
        Method : *GET*
        
        URI : */persons*
        
        :param search: string that represents the beginning of the firstname or lastname of the person
        
        If elements have been found, it returns the list of persons ordered by lastname:
        
        **{persons: [
            {"id" : 1, 
            "firstname" : "John", 
            "lastname"  : "Arthur", 
            "birthdate" : "1984-03-24"
            },
            {"id" : 2, 
            "firstname" : "Johnny", 
            "lastname"  : "Bertrand", 
            "birthdate" : "1981-01-18"
            }
          }
        **
        
        If no elements have been found, it returns an empty list
        
        The request can also returns the following error codes :
        
        ==== =========================
        Code Reason
        ==== =========================
        400  Search parameter is empty
        ==== =========================
    """
    
    persons = None
    
    if 'search' in request.values:
        
        if len(request.values['search']) == 0:
            abort(400, u"Search parameter is empty")
        else:
            search = request.values['search']+'%'
            persons = Person.query.filter(or_(Person.firstname.ilike(search), Person.lastname.ilike(search))).order_by(Person.lastname).all()
    else:
        persons = Person.query.order_by(Person.lastname).all()
 
    lst_persons = list()
    for person in persons:
        lst_persons.append(person.to_dict())
        
    response = make_response(jsonify(dict(persons=lst_persons)))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response
    
@persons.route('', methods=['POST'])
def create():
    """ This service should enable to create a new person """
    pass
    
@persons.route('/<int:id>', methods=['PUT'])
def update(id):
    """ Update an existing person
        
        Method : *PUT*
        
        URI : */persons/{id}*
        
        :param id: identifier of the person to update
        
        If elements have been updated, it returns 200 with the id of the updated person:
        
        **{"id": 2}**
        
        If no elements have been found, it returns an empty list
        
        The request can also returns the following error codes :
        
        ==== ==========================
        Code Reason
        ==== ==========================
        404  Person not found
        400  Firstname can not be empty
        400  Lastname can not be empty
        ==== ==========================
    """
    # TODO Create your webservice here !
    # Note : Do not forget to write your tests before your code ;)
    # For more information about TDD : http://fr.wikipedia.org/wiki/Test_Driven_Development
    
    p = Person.query.get(id)
    p.firstname = request.form['firstName']
    p.lastname = request.form['lastName']
    session.commit()
    
    #session.query(Person).filter(Person.id == id).update({'firstname': request.form['firstName'], 'lastname':request.form['lastName']})

    response = make_response()
    response.status_code = 200
    response.mimetype = 'application/json'
    return response
    
@persons.route('/<int:id>', methods=['DELETE'])
def delete(id):
    """ This service should enable to delete a person """
    pass

@persons.route('/addToTeam/<int:idPerson>', methods=['PUT', 'POST'])
def addToTeam(idPerson):
    #print(idPerson + " - " + idTeam )
    idTeam = request.form['idTeam']
    print(str(idPerson) + " - " + idTeam)

    p = Person.query.get(idPerson)
    t = Team.query.get(idTeam)
    print(t.name)
    print(p.teams)
    p.teams.append(t)
    print(p.teams)
    session.commit()

    response = make_response()
    response.status_code = 200
    response.mimetype = 'application/json'
    return response
