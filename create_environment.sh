#!/bin/bash

read -p "Enter your name : " name

mkdir -p submission_reminder_$name

cd submission_reminder_$name

mkdir -p app 
cd app

cat > reminder.sh << 'EOF'

#!/bin/bash

source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

cd ..
mkdir -p modules 
cd modules
cat > functions.sh << 'EOF'

#!/bin/bash

function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOF
cd ..
mkdir assets
cd assets
cat > submissions.txt << 'EOF'

student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Umulisa, shell permissions, submitted
Briella, Python, submitted
Ella, C++,submitted
Okosugo, Shell Navigation, not submitted
Shema, shell Redirections and filters, submitted
sylvie, team dynamics, not submitted
Anne, C, submitted
Emma, JavaScript, submitted
John, Data Structures, submitted
Lily, Python, not submitted
John, Python, not submitted
Jane, Python, not submitted
Mark, Shell Navigation, submitted
EOF
cd ..
mkdir -p config
cd config
cat > config.env << 'EOF'

ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF
cd ..
cat > startup.sh << 'EOF'

#!/bin/bash

bash app/reminder.sh
EOF

chmod +x startup.sh modules/functions.sh
./startup.sh
