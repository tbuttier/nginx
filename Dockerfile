#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
ARG									\
	tag="1.19.0-alpine"
ARG									\
	digest="@sha256:bf8ebb8068d7ff10711c1670398eeaa83283a7987cdc9b9b014560dbba71773c"
FROM									\
	nginx:${tag}${digest}						\
		AS nginx
#########################################################################
RUN									\
	for package in							\
		$(							\
			for x in 0 1 2 3 4 5 6 7 8 9;			\
			do						\
				apk list				\
				| awk /nginx/'{ print $1 }'		\
				| awk -F-$x  '{ print $1 }'		\
				| grep -v '\-[0-9]';			\
			done						\
			| sort						\
			| uniq						\
			| grep -v ^nginx$				\
		);							\
	do								\
		apk del $package;					\
	done
#########################################################################
RUN									\
	rm -rf /etc/nginx/conf.d					\
		&& ln -s /run/secrets/etc/nginx/conf.d /etc/nginx
#########################################################################
