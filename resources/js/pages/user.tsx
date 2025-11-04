export default function User(props: { name: string }) {
    return (
        <div>
            <div>Hello, {props.name} </div>
            <div></div>
        </div>
    );
}
