import docker
import sys
import webbrowser
import time

def run_container_and_stream_output(image_name, container_name):
    client = docker.from_env()

    # Run the container
    container = client.containers.run(
        image_name,
        name=container_name,
        detach=True,
        ports={
            '1880/tcp': 1880,
            '5432/tcp': 5432,
            '1883/tcp': 1883
        }
    )

    print(f"Container {container_name} is running.")

    print("loading browser windows...")
    time.sleep(2)

    # open browser:
    node_red_flow_url = 'http://localhost:1880'
    webbrowser.open(node_red_flow_url, new=2)
    dashboard_url = 'http://localhost:1880/ui'
    webbrowser.open(dashboard_url, new=2)

    # Stream the container's output
    for line in container.logs(stream=True, follow=True):
        sys.stdout.buffer.write(line)
        sys.stdout.buffer.flush()

if __name__ == "__main__":
    image_name = "nodered-server"  # Replace with your image name
    container_name = "railred"  # Replace with your desired container name
    
    run_container_and_stream_output(image_name, container_name)