Rails-Start-Template
====================

My personal common template that I usually use when starting a rails project.
Whenever I start a new project, I usually go back to this configuration.
So here it is.

What I did
----------

- Added some gems
- Preadd bootstrap theme for simple_form
- A modified pundit application_policy with `mutate?``
- settings.yml with a class to load it
- Some preinstalled capistrano configuration, which setup rbenv, and stuff.

How to deploy
-------------

- Push the code to a remote git repository.
- Modify config/deploy.yml according to your application.
- `cap staging config:init`
  - The modify the configuration as you see fit.
  - Make sure you put something as the secret base.
  - Make sure the database has been added on the server.
- `cap staging config:push`
- `cap staging deploy`
- `cap staging setup:service`
  - This need to be run after every deploy change.
- `cap staging nginx:site:add nginx:site:enable`
- `cap staging nginx:reload`
- `cap staging service:start`

It will create an nginx reverse proxy to a unix socket in tmp/sockets
directory and added a service using foreman with the same name as
`:application` settings in capistrano.
