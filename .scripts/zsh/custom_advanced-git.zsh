function exists { which $1 &> /dev/null }

if exists git; then
    
    gitupdate() {
        find . -name ".git" -type d -execdir git pull \; || sudo find . -name ".git" -type d -execdir git pull \;
    }
    
fi