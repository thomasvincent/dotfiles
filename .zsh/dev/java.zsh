#!/usr/bin/env zsh
# java.zsh - Java development environment configuration for macOS

# Ensure Java is installed
if command -v java >/dev/null; then
  # Java version in prompt (macOS optimized)
  java_version() {
    emulate -L zsh
    if [[ -f "pom.xml" || -f "build.gradle" || -f "build.gradle.kts" || -d "src/main/java" ]]; then
      echo "(java:$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1-2))"
    fi
  }

  # Maven shortcuts
  if command -v mvn >/dev/null; then
    alias mvnc="mvn clean"
    alias mvnci="mvn clean install"
    alias mvnct="mvn clean test"
    alias mvncp="mvn clean package"
    alias mvnd="mvn deploy"
    alias mvnp="mvn package"
    alias mvni="mvn install"
    alias mvndev="mvn -Pdev"
    alias mvnprod="mvn -Pprod"
  fi

  # Gradle shortcuts
  if command -v gradle >/dev/null; then
    alias gw="./gradlew"
    alias gwb="./gradlew build"
    alias gwc="./gradlew clean"
    alias gwcb="./gradlew clean build"
    alias gwt="./gradlew test"
    alias gwrun="./gradlew bootRun" # Spring Boot
  fi

  # Spring Boot helpers (macOS optimized)
  spring_run() {
    emulate -L zsh

    if [[ -f "gradlew" ]]; then
      print -P "%F{blue}Starting Spring Boot with Gradle...%f"
      ./gradlew bootRun
    elif [[ -f "mvnw" ]]; then
      print -P "%F{blue}Starting Spring Boot with Maven...%f"
      ./mvnw spring-boot:run
    else
      print -P "%F{yellow}No Spring Boot project found%f"
    fi
  }

  # Groovy support
  if command -v groovy >/dev/null; then
    alias gr="groovy"
    alias grc="groovyc"
  fi

  # Java project initializer
  java-init() {
    local project_name="${1:-java-project}"
    local build_tool="${2:-gradle}"

    if [[ -d "$project_name" ]]; then
      echo "Directory $project_name already exists"
      return 1
    fi

    mkdir -p "$project_name"
    cd "$project_name" || return

    # Create standard Maven/Gradle directory structure
    mkdir -p src/{main,test}/{java,resources}

    # Initialize build tool
    if [[ "$build_tool" == "maven" ]]; then
      # Create simple pom.xml
      cat > pom.xml << 'EOL'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>PROJECT_NAME</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.9.1</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
EOL
      sed -i '' "s/PROJECT_NAME/$project_name/g" pom.xml
    else
      # Create build.gradle
      cat > build.gradle << 'EOL'
plugins {
    id 'java'
    id 'application'
}

group = 'com.example'
version = '1.0-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter:5.9.1'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.9.1'
}

test {
    useJUnitPlatform()
}

application {
    mainClassName = 'com.example.Main'
}
EOL
      # Create settings.gradle
      echo "rootProject.name = '$project_name'" > settings.gradle
    fi

    # Create gitignore
    cat > .gitignore << 'EOL'
# Compiled class files
*.class

# Build directories
/target/
/build/
/out/
/.gradle/
/bin/

# IDE files
/.idea/
/.vscode/
*.iml
*.iws
*.ipr

# Logs
*.log

# Package files
*.jar
*.war
*.ear
*.zip
*.tar.gz
*.rar
EOL

    # Initialize git repo
    git init

    echo "Java project initialized with $build_tool in $project_name"
  }
fi
