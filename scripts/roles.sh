#!/bin/bash

# Date/Time stamp
DATETIME=`date +%d-%m-%Y_%H%M%S`

# Define the path to the ansible configuration file
ANSIBLE_CFG=/etc/ansible/ansible.cfg

# Find the roles path
ANSIBLE_ROLES_PATH=$(awk -F "=" '/roles_path/ {print $2}' $ANSIBLE_CFG)

# The path where to put backups of removed roles
ANSIBLE_ROLES_BACKUP_PATH=$ANSIBLE_ROLES_PATH-backup

# Action
ACTION=$1
ROLE=$2

# Bail out if the ansible configuration file cannot be found
if [[ ! -e $ANSIBLE_CFG ]]; then
  echo "Error: Configuration file $ANSIBLE_CFG does not exist"
  exit 1
fi

# Bail out if the ansible configuration file cannot be read
if [[ ! -r $ANSIBLE_CFG ]]; then
  echo "Error: Configuration file $ANSIBLE_CFG could not be read"
  exit 1
fi

# Bail out if the roles_path option is not set
if [[ $ANSIBLE_ROLES_PATH == "" ]]; then
  echo "Error: configuration option 'roles_path' not defined in $ANSIBLE_CFG"
  exit 1
fi

# Bail out if the roles_path does not exist
if [[ ! -e $ANSIBLE_ROLES_PATH ]]; then
  echo "Error: roles_path $ANSIBLE_ROLES_PATH does not exist"
  exit 1
fi 

# Bail out if the roles_path is not a directory 
if [[ ! -d $ANSIBLE_ROLES_PATH ]]; then
  echo "Error: roles_path $ANSIBLE_ROLES_PATH is not a directory"
  exit 1
fi

# Bail out if the roles backup path does not exist
if [[ ! -e $ANSIBLE_ROLES_BACKUP_PATH ]]; then
  echo "Error: roles_path $ANSIBLE_ROLES_BACKUP_PATH does not exist"
  exit 1
fi

# Bail out if the roles backup path is not a directory
if [[ ! -d $ANSIBLE_ROLES_BACKUP_PATH ]]; then
  echo "Error: roles_path $ANSIBLE_ROLES_BACKUP_PATH is not a directory"
  exit 1
fi

# Bail out if the ACTION is not add or remove
if [[ $ACTION != "add" && $ACTION != "remove" ]]; then
  echo "Usage: $0 add|remove <role>"
  exit 1
fi 

# Bail out if the role is not defined
if [[ $ROLE == "" ]]; then
  echo "Usage: $0 add|remove <role>"
  exit 1
fi

# Bail out if the action is remove but the role doesn't exist
if [[ $ACTION == "remove" && ! -e $ANSIBLE_ROLES_PATH/$ROLE ]]; then
  echo "Error: Role $ROLE does not exist in $ANSIBLE_ROLES_PATH"
  exit 1
fi

# Bail out if the action is add but the role already exists
if [[ $ACTION == "add" && -e $ANSIBLE_ROLES_PATH/$ROLE ]]; then
  echo "Error: Role $ROLE already exists in $ANSIBLE_ROLES_PATH"
  exit 1
fi

##########
# Add role
##########
if [[ $ACTION == "add" ]]; then
  echo "Setting up ansible role $ROLE in $ANSIBLE_ROLES_PATH..."
  # Create directories
  mkdir -p $ANSIBLE_ROLES_PATH/$ROLE/tasks
  mkdir -p $ANSIBLE_ROLES_PATH/$ROLE/handlers
  mkdir -p $ANSIBLE_ROLES_PATH/$ROLE/templates
  mkdir -p $ANSIBLE_ROLES_PATH/$ROLE/files
  mkdir -p $ANSIBLE_ROLES_PATH/$ROLE/vars
  mkdir -p $ANSIBLE_ROLES_PATH/$ROLE/defaults
  mkdir -p $ANSIBLE_ROLES_PATH/$ROLE/meta
  
  # Touch files
  touch $ANSIBLE_ROLES_PATH/$ROLE/tasks/main.yml 
  touch $ANSIBLE_ROLES_PATH/$ROLE/handlers/main.yml 
  touch $ANSIBLE_ROLES_PATH/$ROLE/templates/jinja2.filter.j2.example
  touch $ANSIBLE_ROLES_PATH/$ROLE/vars/main.yml 
  touch $ANSIBLE_ROLES_PATH/$ROLE/defaults/main.yml 
  touch $ANSIBLE_ROLES_PATH/$ROLE/meta/main.yml 

  echo "# Please see http://docs.ansible.com/ansible/playbooks_filters.html for examples of Jinja2 filters" >> $ANSIBLE_ROLES_PATH/$ROLE/templates/jinja2.filter.j2.example
  
  echo "Role $ROLE created succesfully in $ANSIBLE_ROLES_PATH"  
fi
 
##########
# Remove role
##########
if [[ $ACTION == "remove" ]]; then
  echo "Removing ansible role $ROLE in $ANSIBLE_ROLES_PATH..."
  echo "Creating backup in $ANSIBLE_ROLES_BACKUP_PATH/$ROLE-backup-$DATETIME.tar.gz ..."
  cd $ANSIBLE_ROLES_PATH && tar -czf $ANSIBLE_ROLES_BACKUP_PATH/$ROLE-backup-$DATETIME.tar.gz $ROLE 

  # Bail out if the backup failed
  if [[ $? -ne 0 ]]; then
    echo "Error: backup failed, bailing out"
    exit 1
  fi
  rm -rf $ANSIBLE_ROLES_PATH/$ROLE
  echo "Role $ROLE removed succesfully in $ANSIBLE_ROLES_PATH"
fi


