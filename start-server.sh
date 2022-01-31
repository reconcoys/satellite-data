#!/bin/bash
bin/rails db:schema:load
bin/rails server -b 0.0.0.0