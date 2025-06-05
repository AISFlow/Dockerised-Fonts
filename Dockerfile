FROM debian:bookworm AS fonts
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    unzip tree wget jq ca-certificates fontconfig

# Workdir for fonts
WORKDIR /fonts
# D2Coding

ARG D2CODING_VERSION=1.3.2
ARG D2CODING_DATE=20180524
ARG PRETENDARD_VERSION=1.3.9

# Download D2Coding fonts
ADD https://github.com/naver/d2codingfont/releases/download/VER${D2CODING_VERSION}/D2Coding-Ver${D2CODING_VERSION}-${D2CODING_DATE}.zip /fonts/D2Coding.zip
RUN unzip /fonts/D2Coding.zip -d /fonts/D2Coding

# Download Noto Sans KR fonts
ADD https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKkr-hinted.zip /fonts/NotoSansCJKkr.zip
RUN unzip /fonts/NotoSansCJKkr.zip -d /fonts/NotoSansCJKkr

# Download Noto Serif KR fonts
ADD https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKkr-hinted.zip /fonts/NotoSerifCJKkr.zip
RUN unzip /fonts/NotoSerifCJKkr.zip -d /fonts/NotoSerifCJKkr

# Download Noto Sans JP fonts
ADD https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip /fonts/NotoSansCJKjp.zip
RUN unzip /fonts/NotoSansCJKjp.zip -d /fonts/NotoSansCJKjp

# Download Noto Serif JP fonts
ADD https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKjp-hinted.zip /fonts/NotoSerifCJKjp.zip
RUN unzip /fonts/NotoSerifCJKjp.zip -d /fonts/NotoSerifCJKjp

# Download Pretendard fonts
ADD https://github.com/orioncactus/pretendard/releases/download/v${PRETENDARD_VERSION}/Pretendard-${PRETENDARD_VERSION}.zip /fonts/Pretendard.zip
RUN unzip /fonts/Pretendard.zip -d /fonts/Pretendard

# Download Pretendard JP fonts
ADD https://github.com/orioncactus/pretendard/releases/download/v${PRETENDARD_VERSION}/PretendardJP-${PRETENDARD_VERSION}.zip /fonts/PretendardJP.zip
RUN unzip PretendardJP.zip -d /fonts/PretendardJP

# Delete the zip files
RUN rm /fonts/*.zip

# Check the fonts list using tree and make markdown file
RUN tree /fonts

###############################
# Additional Build Arguments
###############################
ARG D2CODING_VERSION=1.3.2
ARG D2CODING_NERD_VERSION=1.3.2
ARG D2CODING_DATE=20180524
ARG PRETENDARD_VERSION=1.3.9

# Install the fonts
RUN set -eux; \
        install_google_font() { \
        local relative_path="$1"; local font_name="$2"; \
        local font_dir="/usr/share/fonts/truetype/${relative_path}"; \
        mkdir -p "${font_dir}" && \
        local encoded_font_name=$(printf "%s" "${font_name}" | jq -sRr @uri); \
        wget --quiet -O "${font_dir}/${font_name}" "https://raw.githubusercontent.com/google/fonts/17216f1645a133dbbeaa506f0f63f701861b6c7b/ofl/${relative_path}/${encoded_font_name}"; \
    }; \
    \
    # Install the D2Coding font
    mkdir -p /usr/share/fonts/truetype/D2Coding && \
        wget --quiet -O /usr/share/fonts/truetype/D2Coding.zip "https://github.com/naver/d2codingfont/releases/download/VER${D2CODING_VERSION}/D2Coding-Ver${D2CODING_VERSION}-${D2CODING_DATE}.zip" && \
        unzip /usr/share/fonts/truetype/D2Coding.zip -d /usr/share/fonts/truetype/ && \
    rm /usr/share/fonts/truetype/D2Coding.zip && \
    \
    # Install the D2Coding Nerd font
    mkdir -p /usr/share/fonts/truetype/D2CodingNerd && \
    wget --quiet -O /usr/share/fonts/truetype/D2CodingNerd/D2CodingNerd.ttf "https://github.com/kelvinks/D2Coding_Nerd/raw/master/D2Coding%20v.${D2CODING_NERD_VERSION}%20Nerd%20Font%20Complete.ttf" && \
    \
    # Install the Pretendard and PretendardJP fonts
    mkdir -p /usr/share/fonts/truetype/Pretendard && \
        wget --quiet -O /usr/share/fonts/truetype/Pretendard.zip "https://github.com/orioncactus/pretendard/releases/download/v${PRETENDARD_VERSION}/Pretendard-${PRETENDARD_VERSION}.zip" && \
        unzip /usr/share/fonts/truetype/Pretendard.zip -d /usr/share/fonts/truetype/Pretendard/ && \
    rm /usr/share/fonts/truetype/Pretendard.zip && \
    mkdir -p /usr/share/fonts/truetype/PretendardJP && \
        wget --quiet -O /usr/share/fonts/truetype/PretendardJP.zip "https://github.com/orioncactus/pretendard/releases/download/v${PRETENDARD_VERSION}/PretendardJP-${PRETENDARD_VERSION}.zip" && \
        unzip /usr/share/fonts/truetype/PretendardJP.zip -d /usr/share/fonts/truetype/PretendardJP/ && \
    rm /usr/share/fonts/truetype/PretendardJP.zip && \
    \
    # Install Noto fonts
        install_google_font "notosans" "NotoSans[wdth,wght].ttf" && \
        install_google_font "notosans" "NotoSans-Italic[wdth,wght].ttf" && \
        install_google_font "notoserif" "NotoSerif[wdth,wght].ttf" && \
        install_google_font "notoserif" "NotoSerif-Italic[wdth,wght].ttf" && \
        install_google_font "notosanskr" "NotoSansKR[wght].ttf" && \
        install_google_font "notoserifkr" "NotoSerifKR[wght].ttf" && \
        install_google_font "notosansjp" "NotoSansJP[wght].ttf" && \
        install_google_font "notoserifjp" "NotoSerifJP[wght].ttf" && \
        install_google_font "notoemoji" "NotoEmoji[wght].ttf" && \
        install_google_font "notocoloremoji" "NotoColorEmoji-Regular.ttf" && \
    \
    # Install Nanum fonts
        install_google_font "nanumbrushscript" "NanumBrushScript-Regular.ttf" && \
        install_google_font "nanumgothic" "NanumGothic-Bold.ttf" && \
        install_google_font "nanumgothic" "NanumGothic-ExtraBold.ttf" && \
        install_google_font "nanumgothic" "NanumGothic-Regular.ttf" && \
        install_google_font "nanumgothiccoding" "NanumGothicCoding-Bold.ttf" && \
        install_google_font "nanumgothiccoding" "NanumGothicCoding-Regular.ttf" && \
        install_google_font "nanummyeongjo" "NanumMyeongjo-Bold.ttf" && \
        install_google_font "nanummyeongjo" "NanumMyeongjo-ExtraBold.ttf" && \
        install_google_font "nanummyeongjo" "NanumMyeongjo-Regular.ttf" && \
    \
    # Install IBM Plex fonts
        install_google_font "ibmplexmono" "IBMPlexMono-Bold.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-BoldItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-ExtraLight.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-ExtraLightItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Italic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Light.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-LightItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Medium.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-MediumItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Regular.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-SemiBold.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-SemiBoldItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Thin.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-ThinItalic.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Bold.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-ExtraLight.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Light.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Medium.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Regular.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-SemiBold.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Thin.ttf" && \
    \
    # Set font permissions and update the cache
    chmod -R 644 /usr/share/fonts/truetype/* && \
    find /usr/share/fonts/truetype/ -type d -exec chmod 755 {} + && \
    fc-cache -f -v

FROM debian:bookworm-slim AS final

COPY --from=fonts --chmod=644 /fonts /usr/share/fonts/polybag/
COPY --from=fonts --chmod=644 /usr/share/fonts/truetype/ /usr/share/fonts/truetype/
