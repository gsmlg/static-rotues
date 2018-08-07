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


macos: clean gencsv
	@OS=Darwin ruby create.rb


linux: clean gencsv
	@OS=Linux ruby create.rb


gencsv:
	@bash download.sh
	@bash get_csv.sh

clean:
	@git clean -df
