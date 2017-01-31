# MEDIN 2.3.7 schema plugin

This is the MEDIN 2.3.7 schema plugin for GeoNetwork 3.x or greater version.

## Installing the plugin

### GeoNetwork version to use with this plugin

Use GeoNetwork 3.2.0+ version.
It'll not be supported in 2.10.x or 3.0.x series so don't plug it into it!

### Adding the plugin to the source code

The best approach is to add the plugin as a submodule into GeoNetwork schema module.

```
cd schemas
git submodule add -b 3.2.x https://github.com/AstunTechnology/iso19139.medin237_GN3 iso19139.medin237
```

Add the new module to the schema/pom.xml:

```
  <module>iso19139</module>
  <module>iso19139.medin237</module>
</modules>
```

Add the dependency in the web module in web/pom.xml:

```
<dependency>
  <groupId>${project.groupId}</groupId>
  <artifactId>schema-iso19139.medin237</artifactId>
  <version>${project.version}</version>
</dependency>
```

Add the module to the webapp in web/pom.xml:

```
<execution>
  <id>copy-schemas</id>
  <phase>process-resources</phase>
  ...
  <resource>
    <directory>${project.basedir}/../schemas/iso19139.medin237/src/main/plugin</directory>
    <targetPath>${basedir}/src/main/webapp/WEB-INF/data/config/schema_plugins</targetPath>
  </resource>
```

### Build the application 

Once the application is build, the war file contains the schema plugin:

```
$ mvn clean install -Penv-prod
```

### Deploy the profile in an existing installation

After building the application, it's possible to deploy the schema plugin manually in an existing GeoNetwork installation:

- Copy the content of the folder schemas/iso19139.medin237/src/main/plugin to INSTALL_DIR/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.medin237 

- Copy the jar file schemas/iso19139.medin237/target/schema-iso19139.medin237-3.2.1-SNAPSHOT.jar to INSTALL_DIR/geonetwork/WEB-INF/lib.

If there's no changes to the profile Java code or the configuration (config-spring-geonetwork.xml), the jar file is not required to be deployed each time.


### Adding editor configuration
Once the application started, check the plugin is loaded in the admin > standard page. Then in admin > Settings, add to metadata/editor/schemaConfig the editor configuration for the schema:

    "iso19139.medin237":{
      "defaultTab":"default",
      "displayToolTip":false,
      "related":{
        "display":true,
        "categories":[]},
      "suggestion":{"display":true},
      "validation":{"display":true}}