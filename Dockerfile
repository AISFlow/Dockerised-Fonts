FROM debian:bookworm AS fonts

# Install dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    unzip tree

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

# Download Pretendard fonts
ADD https://github.com/orioncactus/pretendard/releases/download/v${PRETENDARD_VERSION}/Pretendard-${PRETENDARD_VERSION}.zip /fonts/Pretendard.zip
RUN unzip /fonts/Pretendard.zip -d /fonts/Pretendard

# Download Pretendard JP fonts
ADD https://github.com/orioncactus/pretendard/releases/download/v${PRETENDARD_VERSION}/PretendardJP-${PRETENDARD_VERSION}.zip /fonts/PretendardJP.zip
RUN unzip PretendardJP.zip -d /fonts/PretendardJP

# Download Noto Serif KR fonts
ADD https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKkr-hinted.zip /fonts/NotoSerifCJKkr.zip
RUN unzip /fonts/NotoSerifCJKkr.zip -d /fonts/NotoSerifCJKkr

# Check the fonts list using tree and make markdown file
RUN tree /fonts

FROM debian:bookworm-slim AS final

COPY --from=fonts --chmod=644 /fonts /fonts