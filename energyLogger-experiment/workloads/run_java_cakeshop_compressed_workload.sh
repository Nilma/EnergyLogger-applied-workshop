#!/bin/bash

for i in {1..200}; do
  curl -s http://localhost:8081/index.html > /dev/null
done