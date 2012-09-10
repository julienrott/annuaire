# -*- coding: utf-8 -*-
import logging

from elixir import session
from flask import abort, Blueprint, jsonify, make_response, request

from annuaireapp import app
from annuaireapp.models import Team

from sqlalchemy import or_

teams = Blueprint('teams', __name__)

@teams.route('', methods=['GET'])
def index():
    teams = Team.query.order_by(Team.name).all()
 
    lst_teams = list()
    for team in teams:
        lst_teams.append(team.to_dict())
        
    response = make_response(jsonify(dict(teams=lst_teams)))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response
    
    
