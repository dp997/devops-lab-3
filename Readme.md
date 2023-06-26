<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="https://i.imgur.com/6wj0hh6.jpg" alt="Project logo"></a>
</p>

<h3 align="center">First lambda deployment</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![GitHub Issues](https://img.shields.io/github/issues/kylelobo/The-Documentation-Compendium.svg)](https://github.com/kylelobo/The-Documentation-Compendium/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/kylelobo/The-Documentation-Compendium.svg)](https://github.com/kylelobo/The-Documentation-Compendium/pulls)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> 
    Using previous projects to launch a database (PostgreSQL on RDS), a lambda that populates it (in Python) and a webapp that displays the data (flask?)
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Deployment](#deployment)
- [TODO](../TODO.md)
- [Authors](#authors)

## 🧐 About <a name = "about"></a>

- [WebApp](https://github.com/dp997/devops-lab-3-webapp)
- [Lambda](https://github.com/dp997/devops-lab-3-lambda)

### Prerequisites

* AWS account (free-tier is fine)
* Terraform installed on your PC
* Python 3.10 with pip


## 🚀 Deployment <a name = "deployment"></a>

Clone the repository and run as a standard terraform project.

## TODO

* <s>Manage dependecies so the infrastracture deploys without hiccups</s> should be fine now
* maybe slim it down a little bit? restructure modules?
* <s>webapp that shows the table</s> <a href="https://github.com/dp997/devops-lab-3-webapp"> WebApp </a>
* api gateway to control lambda function
* <s>ci/cd pipeline with github actions</s> done for lambda

## ✍️ Authors <a name = "authors"></a>

- [@dp997](https://github.com/dp997)


