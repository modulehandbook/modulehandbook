# Asset Pipeline in Module-Handbook

"The Rails Asset Pipeline is a library designed for organizing, caching, and serving static assets, such as JavaScript, CSS, and image files."

see https://guides.rubyonrails.org/v8.0/asset_pipeline.html

## MH uses new rails 8 asset pipeline based on Propshaft (Wednesday, 15.July 2026)

- [Asset Pipeline](https://guides.rubyonrails.org/v8.0/asset_pipeline.html)
- [Propshaft](https://github.com/rails/propshaft)

As the MH needs precompilation for sass files, 
[cssbundling-rails](https://github.com/rails/cssbundling-rails) is used.

- uses app/assets/builds for output
- So you continue to refer to the build output in your layout using the standard asset pipeline approach with <%= stylesheet_link_tag "application" %>

to build the assets: (aka compile everything together to app/assets/builds/application.css)

```
rails build:css
# or directly
npm build:css
```

refer to `package.json` for the definition of these tasks.

### Development

- npm build:css has to be run for initial setup
- if working on the css files, use the watch command to reflect changes immediately:

```
npm run watch:css
```

### Production




### References

- [Asset Pipeline](https://guides.rubyonrails.org/v8.0/asset_pipeline.html)
- [Propshaft](https://github.com/rails/propshaft)
- [cssbundling-rails](https://github.com/rails/cssbundling-rails)


## Migration notes - Wednesday, 15.July 2026 - migration to new asset pipeline

Update to new asset pipeline in rails 8:

- we have scss (sass) files, therefore
https://github.com/rails/cssbundling-rails had to be installed:

```
./bin/bundle add cssbundling-rails
./bin/rails css:install:sass
```

see 
https://guides.rubyonrails.org/v8.0/asset_pipeline.html#cssbundling-rails



for all changes see 
[Commit 9d10e39](https://github.com/modulehandbook/modulehandbook/commit/9d10e3988267cea7ac42cdecfdf945242b5d7b43)
