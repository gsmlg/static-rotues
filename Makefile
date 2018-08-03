default:
	@os=$$(uname -s) ; \
		case "$$os" in \
			Linux) \
				echo "please make linux" ;\
			;; \
			Darwin) \
				echo "please make macos" ;\
			;; \
			*) \
				echo "unsupport system" ;\
			;; \
		esac


macos: gencsv
	OS=Darwin ruby create.rb


linux: gencsv
	OS=Linux ruby create.rb


gencsv:
	bash download.sh
	bash get_csv.sh

