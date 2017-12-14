FROM openjdk:8-jdk
MAINTAINER Mark Sheehan

ENV ANDROID_TARGET_SDK="27" \
    ANDROID_BUILD_TOOLS="27.0.2" \
    ANDROID_SDK_TOOLS_REV="3859397"

# Update and Install Package
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes curl tar lib32stdc++6 lib32z1

# Environment
ENV ANDROID_HOME $PWD/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

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
