# Task Management System

## Overview

This project is a **task management system** built with **Ruby on Rails** (version 7), utilizing **GraphQL** for API interactions and **JWT** for token-based authentication. The system allows users to manage tasks, mark them as completed, track progress, and filter tasks by status and other attributes.

## Features

- **GraphQL API**: Built with Ruby on Rails' API-only mode, providing a flexible and efficient way to query and mutate task data.
- **JWT Authentication**: Secure, token-based authentication for managing users and sessions.
- **Task Management**: Create, update, mark as completed, and filter tasks by status (pending, complete, etc.).
- **Error Handling**: Comprehensive error handling with GraphQL execution errors.
- **Scalability**: Built to support large-scale task data, with optimizations

## Requirements

- Ruby 3.x
- Rails 7.x
- PostgreSQL
- React.js (for frontend)

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/___________________.git
cd todo_graphql
```

### 2. Install dependencies

```bash
 bundle install
```

### 3. Database Setup

```bash
rails db:create
rails db:migrate

rails db:seed  (Optional)
```

### 4. Set up JWT Authentication

```bash
JWT_SECRET_KEY=your_secret_key
```

### 5. Run the server

```bash
rails server
```
