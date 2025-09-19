#!/bin/bash

# Create nixbld users for Nix installation
set -e

echo "Creating nixbld group..."
sudo dscl . -create /Groups/nixbld
sudo dscl . -create /Groups/nixbld PrimaryGroupID 350

echo "Creating nixbld users..."
for i in {1..32}; do
    userid=$((350 + i))
    username="_nixbld$i"
    
    echo "Creating user $username with UID $userid..."
    
    sudo dscl . -create /Users/$username
    sudo dscl . -create /Users/$username UserShell /usr/bin/false
    sudo dscl . -create /Users/$username RealName "Nix build user $i"
    sudo dscl . -create /Users/$username UniqueID $userid
    sudo dscl . -create /Users/$username PrimaryGroupID 350
    sudo dscl . -append /Groups/nixbld GroupMembership $username
done

echo "Verifying nixbld group membership..."
sudo dscl . -read /Groups/nixbld GroupMembership

echo "Done! All nixbld users created successfully."