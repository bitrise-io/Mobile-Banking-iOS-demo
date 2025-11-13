# 🚀 Banking iOS demo served by AWS backend and built by Bitrise on AWS

## 🗺️ Overview

<img align="right" width="181" height="394" alt="iOSDemoApp" src="https://github.com/user-attachments/assets/a3b6a3a1-5fd0-47b9-9431-5e5cde356272" />

We are providing an iOS Banking demo app to showcase mobile app development challenges and the relying on AWS tools and Bitrise's mobile DevOps Platform:

The codebase contains the following components:
- iOS Banking demo app can be found under the BitriseBankingiOSDemo folder
- Serverless User Accounts & Transactions API is powering the iOS Banking demo app, see the setup guide under the BitriseBankingiOSDemoBackend folder
- Bitrise on AWS is used as a Continuous Integration/Continuous Delivery Platform

Bitrise is a mobile DevOps platform that provides automation and security designed for mobile development. Running Bitrise on AWS combines DevOps workflows with Amazon Elastic Compute Cloud (Amazon EC2) Mac instances, giving teams dedicated Apple hardware in the cloud for building iOS applications. Together with services like AWS Device Farm, which runs automated tests on real devices, teams gain an end-to-end environment for secure, fast, and reliable mobile application delivery.

---

<img align="center" width="965" height="586" alt="c6a2f5bb-cccc-4d91-be0a-978f396fe73c" src="https://github.com/user-attachments/assets/d19dd7c6-4d9e-44b1-be8a-0c9601955c91" />

## 🤖 Serverless User Accounts & Transactions API backend

[Check out the Readme for the fully serverless AWS REST API backend](TODO) powering the iOS sample app using the following building blocks:

- API Gateway to expose HTTP endpoints
- AWS Lambda (Python 3.12) to handle backend logic
- DynamoDB for persistent data storage
- AWS CDK (Python) for defining infrastructure as code

## 🤖 Bitrise on AWS

Bitrise provides AMIs for building mobile applications on Amazon EC2 instances with all the tools preinstalled. With the [Bitrise Cloud Controller](https://docs.bitrise.io/en/bitrise-platform/infrastructure/bitrise-on-aws--cloud-controller/bitrise-on-aws-overview.html) it is only a few minutes of configuration to have a fully working MacOS infrastructure on AWS that is ready to run the builds. 

<img align="center" width="802" height="383" alt="513856172-525e8a16-755c-4032-b9e7-51f4d445675d" src="https://github.com/user-attachments/assets/bf71e88f-0fc2-44a6-95bc-1fb881f43c02" />

The Bitrise Cloud Controller managed builder nodes can interact with many Amazon services, like AWS Secrets Manager to access tokens, keys and other secrets required for running CI builds.

The bitrise.yaml file contains the configuration for the Pipeline and the Workflows to build, test and deploy the iOS Banking demo app: 
