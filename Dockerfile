FROM public.ecr.aws/lambda/provided:al2

# 빌드 툴 설치
RUN yum -y install gcc glibc-static && yum clean all

# C 코드 복사 및 빌드
COPY main.c .
RUN gcc -static -o bootstrap main.c

# Lambda는 bootstrap 실행 파일을 진입점으로 사용
CMD ["bootstrap"]
