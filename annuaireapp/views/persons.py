# -*- coding: utf-8 -*-
import logging

from elixir import session
from flask import abort, Blueprint, jsonify, make_response, request

from annuaireapp import app
from annuaireapp.models import Person, Team

from sqlalchemy import or_

persons = Blueprint('persons', __name__)

@persons.route('/<int:id>/', methods=['GET'])
def get(id):
    """ Get a person by id

        Method : *GET*

        URI : */persons/{id}/*
        
        :param id: identifier of the person to get

        If an element has been found the person is return :
        **  {
              "localisation": {
                "building": "Batiment A", 
                "phone": null, 
                "id": 1, 
                "floor": 1
              }, 
              "lastname": "De Monaco", 
              "id": 1, 
              "firstname": "St\u00e9phanie"
            }
        **
        
        The request can also return the following error codes :
        
        ==== ================================
        Code Reason
        ==== ================================
        404  No person found for the given id
        ==== ================================
    """
    person = Person()
    person = Person.query.get(id)

    if person is None:
        return error(404, "person not found")

    return success(jsonify(person.to_dict()))

@persons.route('/', methods=['GET'])
def index():
    """ Get all persons with or without parameters
        
        Method : *GET*
        
        URI : */persons/*
        
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
        
    return success(jsonify(dict(persons=lst_persons)))
    
@persons.route('', methods=['POST'])
def create():
    """ This service should enable to create a new person """
    pass
    
@persons.route('/<int:id>/', methods=['PUT'])
def update(id):
    """ Update an existing person
        
        Method : *PUT*
        
        URI : */persons/{id}*
        
        :param id: identifier of the person to update
        
        If elements have been updated, it returns 200 with the id of the updated person:
        
        **{"id": 2}**
        
        The request can also return the following error codes :
        
        ==== ==========================
        Code Reason
        ==== ==========================
        404  Person not found
        400  Firstname can not be empty
        400  Lastname can not be empty
        ==== ==========================
    """
    
    if not request.form['firstName']:
        return error(400, "Firstname can not be empty")
    
    if not request.form['lastName']:
        return error(400, "Lastname can not be empty")
    
    person = Person.query.get(id)

    if person is None:
        return error(404, "person not found")

    person.firstname = request.form['firstName']
    person.lastname = request.form['lastName']
    session.commit()
    
    return success('{"id":' + str(id) + '}')
    
@persons.route('/<int:id>', methods=['DELETE'])
def delete(id):
    """ This service should enable to delete a person """
    pass

@persons.route('/<int:idPerson>/teams/', methods=['GET'])
def getPersonTeams(idPerson):
    """ Get all teams of a person
        
        Method : *GET*
        
        URI : */persons/{idPerson}/teams/*
        
        :param id: identifier of the person to get the teams from
        
        If elements have been found, it returns the list of teams of the person:
        
        **  {
              "teams": [
                {
                  "leader_id": null, 
                  "id": 1, 
                  "name": "Manchester"
                }
              ]
            }
        **
        
        If no elements have been found, it returns an empty list
        
        The request can also returns the following error codes :
        
        ==== =========================
        Code Reason
        ==== =========================
        404  person not found
        ==== =========================
    """
    
    person = Person.query.get(idPerson)

    if person is None:
        return error(404, "person not found")

    lst_teams = list()
    for team in person.teams:
        lst_teams.append(team.to_dict())
        
    return success(jsonify(dict(teams=lst_teams)))

@persons.route('/<int:idPerson>/teams/<int:idTeam>/', methods=['POST'])
def addToTeam(idPerson, idTeam):
    """ Adds a person to a team
        
        Method : *POST*
        
        URI : */persons/{idPerson}/teams/{idTeam}/*
        
        :param idPerson: identifier of the person to add to a team
        :param idTeam: identifier of the team to add a person
        
        If person succefully added to team returns an empty json object:
        
        **  {}
        **
        
        The request can also returns the following error codes :
        
        ==== =========================
        Code Reason
        ==== =========================
        404  person not found
        404  team not found
        ==== =========================
    """
    
    person = Person.query.get(idPerson)

    if person is None:
        return error(404, "person not found")

    team = Team.query.get(idTeam)

    if team is None:
        return error(404, "team not found")

    person.teams.append(team)
    session.commit()

    return success("{}")

def error(code, message):
    """ returns a response with an error code
        
        :param code: HTTP code to return
        :param message: message to return
        
    """
    
    response = make_response('{"error":"' + message + '"}')
    response.status_code = code
    response.mimetype = 'application/json'
    return response

def success(result):
    """ returns a response with an success code
        
        :param result: object to return
        
    """
    
    response = make_response(result)
    response.status_code = 200
    response.mimetype = 'application/json'
    return response
