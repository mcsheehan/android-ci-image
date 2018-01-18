FROM openjdk:8-jdk
MAINTAINER Mark Sheehan

ENV ANDROID_TARGET_SDK="27" \
    ANDROID_BUILD_TOOLS="27.0.2" \
    ANDROID_SDK_TOOLS_REV="3859397" \
    GRADLE_VERSION="4.1"

# Environment
# Build gradle  Downloading https://services.gradle.org/distributions/gradle-4.1-all.zip
ENV ANDROID_HOME $PWD/android-sdk-linux
ENV GRADLE_STORAGE $PWD/.gradle
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV GRADLE_URL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip 

# Gradle
RUN mkdir ${GRADLE_STORAGE}
RUN curl -sSL "${GRADLE_URL}" -o gradle-${GRADLE_VERSION}-bin.zip  \
    && unzip gradle-${GRADLE_VERSION}-bin.zip -d ${GRADLE_STORAGE}  \
    && rm -rf gradle-${GRADLE_VERSION}-bin.zip

ENV GRADLE_HOME ${GRADLE_STORAGE}/bin
ENV PATH $PATH:${GRADLE_STORAGE}/bin
#ENV PATH $PATH:${GRADLE_HOME}/bin


# Update and Install Package
RUN apt-get --quiet install --yes curl tar git swig build-essential cmake wget pkg-config tar
        
#Swig
#run wget https://netcologne.dl.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz
#run tar xzf swig-3.0.12.tar.gz
#cd swig-3.0.12/
#run ./configure
#run make


# Install Android SDK
# https://developer.android.com/studio/index.html
ENV ANDROID_SDK_ZIP https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_REV}.zip
RUN mkdir ${ANDROID_HOME}
RUN curl -L $ANDROID_SDK_ZIP -o temp.zip && unzip -qq temp.zip -d ${ANDROID_HOME} && rm temp.zip

# Accept licenses
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Update android sdk
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager --update > /dev/null
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager 'tools' \
'platform-tools' \
'extras;android;m2repository' \
'extras;google;google_play_services' \
'extras;google;m2repository' \
'platforms;android-'${ANDROID_TARGET_SDK} \
'build-tools;'${ANDROID_BUILD_TOOLS} \
'ndk-bundle' \
"cmake;3.6.4111459" \
'emulator' > /dev/null
