/*=========================================================================

  Program:   CMake - Cross-Platform Makefile Generator
  Module:    $RCSfile$
  Language:  C++
  Date:      $Date$
  Version:   $Revision$

  Copyright (c) 2002 Kitware, Inc., Insight Consortium.  All rights reserved.
  See Copyright.txt or http://www.cmake.org/HTML/Copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
#include "cmInstallCommandArguments.h"
#include "cmSystemTools.h"

// Table of valid permissions.
const char* cmInstallCommandArguments::PermissionsTable[] =
{
  "OWNER_READ", "OWNER_WRITE", "OWNER_EXECUTE",
  "GROUP_READ", "GROUP_WRITE", "GROUP_EXECUTE",
  "WORLD_READ", "WORLD_WRITE", "WORLD_EXECUTE",
  "SETUID", "SETGID", 0
};

const std::string cmInstallCommandArguments::EmptyString;

cmInstallCommandArguments::cmInstallCommandArguments()
:Parser()
,ArgumentGroup()
,Destination   (&Parser, "DESTINATION"   , &ArgumentGroup)
,Component     (&Parser, "COMPONENT"     , &ArgumentGroup)
,Rename        (&Parser, "RENAME"        , &ArgumentGroup)
,Permissions   (&Parser, "PERMISSIONS"   , &ArgumentGroup)
,Configurations(&Parser, "CONFIGURATIONS", &ArgumentGroup)
,Optional      (&Parser, "OPTIONAL"      , &ArgumentGroup)
,GenericArguments(0)
{
  this->Component.SetDefaultString("Unspecified");
}

const std::string& cmInstallCommandArguments::GetDestination() const
{
  if (!this->AbsDestination.empty())
    {
    return this->AbsDestination;
    }
  if (this->GenericArguments!=0)
    {
    return this->GenericArguments->GetDestination();
    }
  return this->EmptyString;
}

const std::string& cmInstallCommandArguments::GetComponent() const
{
  if (!this->Component.GetString().empty())
    {
    return this->Component.GetString();
    }
  if (this->GenericArguments!=0)
    {
    return this->GenericArguments->GetComponent();
    }
  return this->EmptyString;
}

const std::string& cmInstallCommandArguments::GetRename() const
{
  if (!this->Rename.GetString().empty())
    {
    return this->Rename.GetString();
    }
  if (this->GenericArguments!=0)
    {
    return this->GenericArguments->GetRename();
    }
  return this->EmptyString;
}

const std::string& cmInstallCommandArguments::GetPermissions() const
{
  if (!this->PermissionsString.empty())
    {
    return this->PermissionsString;
    }
  if (this->GenericArguments!=0)
    {
    return this->GenericArguments->GetPermissions();
    }
  return this->EmptyString;
}

bool cmInstallCommandArguments::GetOptional() const
{
  if (this->Optional.IsEnabled())
    {
    return true;
    }
  if (this->GenericArguments!=0)
    {
    return this->GenericArguments->GetOptional();
    }
  return false;
}

const std::vector<std::string>& 
    cmInstallCommandArguments::GetConfigurations() const
{
  if (!this->Configurations.GetVector().empty())
    {
    return this->Configurations.GetVector();
    }
  if (this->GenericArguments!=0)
    {
    return this->GenericArguments->GetConfigurations();
    }
  return this->Configurations.GetVector();
}


bool cmInstallCommandArguments::Finalize()
{
  if (!this->CheckPermissions())
    {
    return false;
    }
  this->ComputeDestination(this->Destination.GetString(),this->AbsDestination);

  return true;
}

void cmInstallCommandArguments::Parse(const std::vector<std::string>* args, 
                                      std::vector<std::string>* unconsumedArgs)
{
  this->Parser.Parse(args, unconsumedArgs);
}


bool cmInstallCommandArguments::CheckPermissions()
{
  this->PermissionsString = "";
  for(std::vector<std::string>::const_iterator 
      permIt = this->Permissions.GetVector().begin(); 
      permIt != this->Permissions.GetVector().end(); 
      ++permIt)
    {
    if (!this->CheckPermissions(*permIt, this->PermissionsString))
      {
      return false;
      }
    }
  return true;
}

bool cmInstallCommandArguments::CheckPermissions(
                    const std::string& onePermission, std::string& permissions)
{
  // Check the permission against the table.
  for(const char** valid = cmInstallCommandArguments::PermissionsTable; 
      *valid; ++valid)
    {
    if(onePermission == *valid)
      {
      // This is a valid permission.
      permissions += " ";
      permissions += onePermission;
      return true;
      }
    }
  // This is not a valid permission.
  return false;
}

//----------------------------------------------------------------------------
void cmInstallCommandArguments::ComputeDestination(const std::string& inDest, 
                                                   std::string& absDest)
{
  if((inDest.size()>0) && !(cmSystemTools::FileIsFullPath(inDest.c_str())))
    {
    // Relative paths are treated with respect to the installation prefix.
    absDest = "${CMAKE_INSTALL_PREFIX}/";
    absDest += inDest;
    }
  else
    {
    // Full paths are absolute.
    absDest = inDest;
    }
  // Format the path nicely.  Note this also removes trailing slashes.
  cmSystemTools::ConvertToUnixSlashes(absDest);
}
