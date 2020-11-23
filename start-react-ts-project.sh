#!/bin/bash

set -e

blue=`tput setaf 6`
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

if [ -z "$1" ]; then
	echo "${red}Project target folder not indicated${reset}"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Initialization
echo "${blue}Initializing package.json with defaults...${reset}"
mkdir $1 && cd $1 && npm init -y
PROJECT_DIR="$(realpath $(pwd))"
echo "${green}OK${reset}"

# Install dev dependencies
echo "${blue}Installing development dependencies...${reset}"
npm install webpack webpack-cli@3 --save-dev
npm install typescript --save-dev
npm install @babel/core babel-loader @babel/preset-react @babel/preset-typescript @babel/preset-env @babel/plugin-proposal-class-properties @babel/plugin-proposal-object-rest-spread --save-dev
npm install css-loader style-loader --save-dev
npm install html-webpack-plugin --save-dev
npm install webpack-dev-server --save-dev
echo "${green}OK${reset}"

# Installing last react version
echo "${blue}Installing react...${reset}"
npm i react react-dom
npm i -D @types/react @types/react-dom
echo "${green}OK${reset}"

# Copying configuration
echo "${blue}Copying webpack configurations...${reset}"
cp -r $DIR/configs/* $PROJECT_DIR/
cp $DIR/configs/.babelrc $PROJECT_DIR/
echo "${green}OK${reset}"

# Adding scripts to package.json
echo "${blue}Adding scripts to package.json...${reset}"
cat $PROJECT_DIR/package.json | jq '.scripts += {"dev": "webpack-dev-server --mode development --open --hot","build": "webpack --mode production"}' | tee $PROJECT_DIR/package.json
echo "${green}OK${reset}"

if [ -z "$2" ]; then
	exit 0
fi

arguments=( "$@" )
# Checking other arguments
for arg in "${arguments[@]}"; do
   if [ "$arg" == "--redux" ]; then
		# Installing redux files
		echo "${blue}Installing redux...${reset}"
		npm i redux react-redux redux-thunk 
		npm i @types/react-redux --save-dev
		cp -r $DIR/plugins/redux/* $PROJECT_DIR/src/
		echo "${green}OK${reset}"
   fi
done

