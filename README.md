# Evaluation Function Base Images

This repository contains base images for evaluation functions written in various languages. The images are intended to be used as base images for evaluation functions that are run in a containerized environment, such as AWS Lambda.

All base images come with [`shimmy`](https://github.com/lambda-feedback/shimmy) pre-installed. Shimmy is an application that allows to run arbitrary evaluation functions in any containerized environment, including AWS Lambda.

## Images

This repository contains the following images:

- [Wolfram](./wolfram): Base image for evaluation functions written in Wolfram Language.
