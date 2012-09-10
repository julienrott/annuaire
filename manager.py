# -*- coding: utf-8 -*-
from datetime import date
from flaskext.script import Manager

from annuaireapp import app
from annuaireapp.models import Person, Localisation, Team

from elixir import session, create_all, drop_all

manager = Manager(app)

@manager.command
def install():
    """ Install database an default values """

    # Drop tables
    print("Dropping all tables...")
    drop_all()

    # Create tables
    print("Creating all tables...")
    create_all()
    
    
    # Create default data
    buildingA = Localisation(building=u"Batiment A", floor=1)
    buildingB = Localisation(building=u"Batiment B", floor=1, phone=u"5104")
    buildingC = Localisation(building=u"Batiment C", floor=2, phone=u"3388")
    
    Person(firstname=u"Stéphanie", lastname=u"De Monaco", birthdate=date(1980, 4, 4), localisation=buildingA)
    Person(firstname=u"Jean", lastname=u"Delarue", birthdate=date(1960, 10, 6), localisation=buildingA)
    Person(firstname=u"Jean-Pierre", lastname=u"Pernault", birthdate=date(1981, 7, 4), localisation=buildingB)
    Person(firstname=u"Anne", lastname=u"Sinclair", birthdate=date(1975, 8, 7), localisation=buildingC)
    Person(firstname=u"Julien", lastname=u"Lepers", birthdate=date(1975, 8, 7), localisation=buildingC)

    Team(name=u"Manchester")
    Team(name=u"Barça")
    Team(name=u"Racing Club de Strasbourg")
    
    session.commit()
    
    print("Installation success with data test")
    
if __name__ == "__main__":
    manager.run()

