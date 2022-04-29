@echo on
cd ../functions
start firebase serve --only functions
start npm run build -- --watch