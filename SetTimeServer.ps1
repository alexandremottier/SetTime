# On indique au service de gestion de temps d'utiliser fr.pool.ntp.org pour la synchronisation horaire

Write-Host ""

Write-Host -ForegroundColor Yellow -NoNewline "Modification du serveur de synchronisation en fr.pool.ntp.org... "
w32tm /config /syncfromflags:MANUAL /manualpeerlist:"fr.pool.ntp.org" | Out-Null

if($Error.Count -ne 0) #Si on a une erreur
{  
    Write-Host -ForegroundColor DarkRed "Erreur !"
	Write-Host -ForegroundColor DarkRed $error[0] #Affichage de l'erreur
    break  # On sort du programme en cas d'erreur
}else {
    Write-Host -ForegroundColor Green "OK"
}

# Redémarrage de service de gestion du temps Windows

Write-Host ""

Write-Host -NoNewline -ForegroundColor Yellow "Redémarrage du service w32time... "

net stop w32time | Out-Null
net start w32time | Out-Null

if($Error.Count -ne 0) #Si on a une erreur
{  
    Write-Host -ForegroundColor DarkRed "Erreur :"
	Write-Host -ForegroundColor DarkRed $error[0] #Affichage de l'erreur
    break  # On sort du programme en cas d'erreur
}else {
    Write-Host -ForegroundColor Green "OK"
}

# On relance une synchronisation horaire sur le nouveau serveur configuré

Write-Host ""

Write-Host -ForegroundColor Yellow -NoNewline "Resynchronisation de l'heure... "

w32tm /resync | Out-Null

if($Error.Count -ne 0) #Si on a une erreur
{  
    Write-Host -ForegroundColor DarkRed "Erreur : "
	Write-Host -ForegroundColor DarkRed $error[0] #Affichage de l'erreur
    break  # On sort du programme en cas d'erreur
}else {
    Write-Host -ForegroundColor Green "OK"
}

# On vérifie que tout est bien OK

Write-Host ""

w32tm /query /status | Write-Host

pause # Pour donner le temps de voir le retour avant de fermer la fenêtre.