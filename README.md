# Book Club API

This is a Ruby on Rails API for a book club application.

## Setup with Docker Compose (Recommended for Development)

This project can be easily set up and run using Docker Compose, which handles all dependencies and environment configurations.

### Prerequisites

Before you begin, ensure you have the following installed on your machine:

*   **Git**: For cloning the repository.
*   **Docker Desktop** (or Docker Engine and Docker Compose): Docker Desktop includes Docker Engine, Docker CLI client, Docker Compose, Kubernetes, and Credential Helper.

### Getting Started

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/book_club_api.git # Replace with your actual repository URL
    cd book_club_api
    ```

2.  **Build the Docker images:**
    This command builds the Docker images for your application and its services (e.g., PostgreSQL).

    ```bash
    docker compose build
    ```

3.  **Start the services:**
    This will start the PostgreSQL database and your Rails application in detached mode (in the background).

    ```bash
    docker compose up -d
    ```

4.  **Prepare the database:**
    Once the services are running, you need to create and migrate the database.

    ```bash
    docker compose exec web bundle exec rails db:create db:migrate
    ```

    If you have seed data, you can also run:
    ```bash
    docker compose exec web bundle exec rails db:seed
    ```

5.  **Access the application:**
    Your Rails API should now be running and accessible at `http://localhost:3000`.

### Stopping the Services

To stop all running Docker containers for this project:

```bash
docker compose down
```

### Running Tests

To run the test suite within the Docker container:

```bash
docker compose exec web bundle exec rspec
# Or for Rails default tests:
# docker compose exec web bundle exec rails test
```

### Troubleshooting

*   **"Address already in use"**: If you see this error when starting the `web` service, it means something else is already using port 3000 on your host machine. You can either stop the other process or change the port mapping in `docker-compose.yml`.
*   **Database connection issues**: Ensure the `db` service is running and healthy. You can check its logs with `docker compose logs db`.
*   **Changes not reflecting**: If you modify your code and the changes don't appear in the running application, ensure your `volumes` are correctly configured in `docker-compose.yml` and that your editor is saving changes.

---

## Local Development (Without Docker - Advanced)

If you prefer to run the application directly on your machine without Docker, you will need to manually install Ruby, Rails, PostgreSQL, and all other dependencies. This approach is generally more complex and less recommended for quick setup.

*   **Ruby version**: Check `.ruby-version` for the required Ruby version.
*   **System dependencies**: Install PostgreSQL and other system libraries as needed.
*   **Bundle install**: `bundle install`
*   **Database setup**: `rails db:create db:migrate`
*   **Run server**: `rails s`
