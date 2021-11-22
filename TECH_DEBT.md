# Technical debt

This document describes outstanding technical debt and how it could be addressed.

## Improve `authenticate_subscription` before action

The way that the `ApplicationController` checks for a valid subscription can be improved. This is tested by cucumber but would be nicer to add some unit tests so it's easier to refactor.

## Consider adding `trialing` state to `Subscription` model

When the trial period becomes more important, it might make more sense to define a separate state for it as well. Don't have a good reason for that yet, though...

## Setup a queuing backend to handle async. processes properly

A potential use case is sending [reminder emails](lib/tasks/wingzzz.rake) triggered by an Heroku Scheduler. These mail are now being sent synchronously. If the number of mails increases and the process take more than a couple of minutes, Heroku advices to use a background job to handle this.
