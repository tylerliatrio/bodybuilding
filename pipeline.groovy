    def notifySlack(color, message){
         slackSend channel: 'jenkins', color: color, message: "${env.JOB_NAME} ${env.BUILD_NUMBER}"+ ' ' + message, teamDomain: 'gnoper', token: 'Ps6s1Zd24uqOGlUP3h5AIDvS'
    }

    def sendEmail(body, subject, toAddress){
         emailext body: body, subject: subject, to: toAddress
    }

node {

    try{
       stage('Pull master') { // for display purposes
            git credentialsId: '6dcdbc96-07e4-427b-940a-89e4ffd4349d', url: 'https://github.com/piratmc/bodybuilding.git'
       }
       stage('Run Bundler') {
           sh 'bundle update'
       }
       stage('Start Postgres') {
           sh 'pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
       }
       stage('Prep DB'){
           sh 'rake db:create'
           sh 'rake db:migrate'
       }
       stage('Run Tests') {
           sh 'bundle exec rake test'
       }
       stage('Kill Rails'){
           try {
                sh '/bin/kill -9 $(/usr/sbin/lsof -i tcp:3000 -t)'
           } catch (e){

           }
       }
       stage('Start Rails'){
           sh 'rails s -d'
           //input 'Are we good to push to PROD?'
       }
       stage('Notify Slack'){
           notifySlack('good','is Deployed to PROD')
       }
       stage('Send Email'){
           sendEmail('Successfully deployed to PROD', "Pushed to PROD", 'dmtrkz@yahoo.com')
       }
    } catch (e) {
        notifySlack('danger', 'build FAILED')
        sendEmail('Something is failing in the build. Please check logs', 'Deployment FAILED', 'dmtrkz@yahoo.com')
        throw e
    }
}