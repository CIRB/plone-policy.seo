Dev
===

Make this for developpment ::

  $ git clone git@github.com:CIRB/plone-buildout-seo.git seo
  $ cd seo
  $ ln -s dev.cfg buildout.cfg
  $ python bootstrap.py
  $ bin/buildout -Nt 3

Start instance for dev ::

  $ bin/intance fg

Stopping instance with ctrl + c
