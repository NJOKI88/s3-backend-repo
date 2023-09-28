module.exports = { 
    branches: "main", 
    repositoryUrl: "https://github.com/NJOKI88/s3-backend-repo.git", 
    plugins: [ 
      '@semantic-release/commit-analyzer', 
      '@semantic-release/release-notes-generator', 
      '@semantic-release/git', 
      '@semantic-release/github'] 
     }