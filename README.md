# S7ack - Gamification API

*Etudiants : Bonzon Ludovic, Delhomme Claire, Mercado Pablo & Vaz Afonso Vitor*

## Choix d'implémentation

Utilisation d'une base de données MySQL dans les 2 projets

...

### Lien entre serveur S7ack et serveur de gamification

// INSERT DIAGRAMME DE CLASSES HERE ???

### Paliers et attribution points et badges au travers des règles

// TODO : Vitor

## Tests

// TODO : Claire

### Ce qui a été testé

### Comment

## État du projet

Le projet est dans un état stable et fonctionnel. Des tests permettent d'évaluer le fonctionnement des différents
composants, comme indiqué au point précédent.

### Ce qui fonctionne

Tous les endpoints tels que définis dans [la documentation d'API](http://localhost:8080/v3/api-docs) sont fonctionnels.

La page de statistiques a été agrémentée de la présence de toutes les leaderboards relatifs à une point scale présents
dans notre application

// INSERT SCREENSHOT HERE

La page de profil d'un utilisateur contient désormais en plus des statistiques globales sur le nombre de quesions posées
et de réponses données, une section comportant tous les badges reçus suite aux actions effectuées sur le site et une
section comportant le score dans chaque point scale où l'utilisateur possède des points.

// INSERT SCREENSHOT HERE

### Ce qui ne fonctionne pas

- Nous n'avons pas implémenté de système de pagination pour les ressources obtenues au travers de l'API

## Procédure d'exécution des projets en local

### Données "démo" via scripts SQL

Nous tenons à signaler que des scripts d'insertion de données "démo" sont présents et activés dans nos 2 projets par
défaut. Ils prennent la forme de 2 scripts SQL de création base de données et d'insertions de données. Les scripts sont
présents pour les 2 projets dans `docker/init/db` et sont copiés dans les fichiers `docker-compose` au moyen du
paramètre suivant :

```dockerfile 
# in file: docker-compose.yml
volumes:
        - ./docker/init/db:/docker-entrypoint-initdb.d
```

Vous pouvez donc aisément désactiver ce paramètre pour ne pas insérer de données de démo.

### Procédure de démarrage en local

Concernant la procédure de démarrage des 2 applications, il faut simplement se rendre dans les dossiers `scripts/` de
chaque projet, et lancer dans cet ordre :

Pour le projet_2 (**Gamification API**) : `./runREST_API.sh`

Pour le projet_1 (**S7ack**) : `./startDocker.sh`

Une fois les scripts exécutés, patienter quelques instants pour s'assurer que tous les composants ont bien été démarrés.

Puis se rendre sur [http://localhost:9080/stack/questions](http://localhost:9080/stack/questions) et profiter de
l'application et de ses capacités de gamification !

### Si vous n'utilisez pas les scripts d'insertion de données de démo

#### API-Key dans `.env`

Pour effectuer des requêtes vers l'API, il est nécessaire d'avoir enregistré l'application au moteur de gamification au
moyen d'une requête `POST /applications` en fournissant un nom et une description de votre application. Ceci vous
retournera une clé d'API unique qu'il sera nécessaire de placer dans le fichier contenant les variables
d'environnement (pour S7ack c'est dans : `src/main/liberty/config/server.env`).

#### Création manuelle de données

Il faut penser à créer manuellement (via des requêtes curl ou via l'interface web swagger) des règles, point scales et
badges, sinon tous les évènements créés à partir d'interaction avec S7ack n'auront aucun impact sur le côté gamifié de
notre application.

### Procédure de démarrage depuis GitHub Registry

// TODO : Pablo

### Running REST-API latest

```bash
cd scripts
./pullREST_API.sh
```

### Test REST-API

```bash
cd scripts
./testREST_API.sh
```

**Note**: for faster local testing (from 1m30 to 5s), you can `cd` into `/gamification-specs`, change the url
of `pom.xml` (l22) from http://api:8080 to http://localhost:8080 then run `mvn clean test`. Because this url is used in
the pipeline, please donc forget to change it back when pushing to master.

## Problèmes rencontrés

- Règles difficiles à mettre en place (pour prendre en compte les concepts de point scales, de badges et de paliers),
  notamment en ce qui concerne le lien avec les évènements internes (lorsqu'un palier est franchi à la réception d'un
  évènement, il faut pouvoir renvoyer un évènement pour traiter par exemple l'attribution d'un badge)

## Build and run the Fruit microservice

You can use maven to build and run the REST API implementation from the command line. After invoking the following maven
goal, the Spring Boot server will be up and running, listening for connections on port 8080.

```
cd fruits-impl/
mvn spring-boot:run
```

You can then access:

* the [API documentation](http://localhost:8080/swagger-ui.html), generated from annotations in the code
* the [API endpoint](http://localhost:8080/), accepting GET and POST requests

You can use curl to invoke the endpoints:

* To retrieve the list of fruits previously created:

```
curl -X GET --header 'Accept: application/json' 'http://localhost:8080/fruits'
```

* To create a new fruit (beware that in the live documentation, there are extra \ line separators in the JSON payload
  that cause issues in some shells)

```
curl -X POST --header 'Content-Type: application/json' --header 'Accept: */*' -d '{
  "colour": "red",
  "expirationDate": "2020-11-06",
  "expirationDateTime": "2020-11-06T05:43:27.909Z",
  "kind": "apple",
  "size": "small",
  "weight": "light"
}' 'http://localhost:8080/fruits'
```

## Test the Fruit microservice by running the executable specification

You can use the Cucumber project to validate the API implementation. Do this when the server is running.

```
cd cd fruits-specs/
mvn clean test
```

You will see the test results in the console, but you can also open the file located in `./target/cucumber`
