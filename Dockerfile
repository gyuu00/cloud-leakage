FROM public.ecr.aws/lambda/provided:al2

RUN yum -y install gcc && yum clean all

COPY main.c .
RUN gcc -static -o main main.c

CMD ["main"]
