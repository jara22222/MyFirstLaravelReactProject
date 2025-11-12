import Addtodoform from '@/components/addtodoform';
import EditTodoform from '@/components/edittodoform';
import Listcard from '@/components/listcard';
import AppLayout from '@/layouts/app-layout';
import { todolist } from '@/routes';
import { BreadcrumbItem } from '@/types';
import { Head, usePage } from '@inertiajs/react';
import { useEffect, useRef, useState } from 'react';
import toast, { Toaster } from 'react-hot-toast';

export default function TodoList(props: { list: Array<any> }) {
    const { list } = props;

    const breadcrumbs: BreadcrumbItem[] = [
        {
            title: 'Todolist',
            href: todolist().url,
        },
    ];

    const { flash } = usePage().props as {
        flash?: {
            success?: string;
            error?: string;
            titleError?: string;
            descriptionError?: string;
        };
    };

    const shownToast = useRef(false);

    useEffect(() => {
        if (flash?.success) {
            toast.success(flash.success);
        } else if (flash?.error) {
            toast.error(flash.error);
        }
        shownToast.current = true;
    }, [flash]);

    const [isPressed, setIsPressed] = useState(false);

    const handleEdit = (value: boolean) => {
        setIsPressed(value);
        console.log(value);
    };

    const [title, setTitle] = useState('');
    const [id, setId] = useState('');
    const [description, setDescription] = useState('');

    const editForm = (newId: any, newTitle: any, newDescription: any) => {
        setId(newId);
        setTitle(newTitle);
        setDescription(newDescription);
        console.log(newId);
        console.log(newTitle);
        console.log(newDescription);
    };

    const cancelEdit = (val: boolean) => {
        setIsPressed(val);
    };

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Todolist" />

            <Toaster position="top-right" />
            <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                <div className="m:w-full grid items-start gap-2 sm:grid-cols-1 md:grid-cols-1 lg:grid-cols-2">
                    {isPressed ? (
                        <>
                            <EditTodoform
                                initialId={id}
                                initialTitle={title}
                                initialDescription={description}
                                cancelEdit={cancelEdit}
                            />
                        </>
                    ) : (
                        <Addtodoform
                            titleError={flash?.titleError}
                            descriptionError={flash?.descriptionError}
                        />
                    )}
                    <div className="Lists flex max-h-[500px] flex-col gap-3 overflow-y-auto py-2">
                        {list.length <= 0 ? (
                            <>
                                <div className="flex min-h-100 flex-col items-center justify-center text-[14px] text-gray-500">
                                    🌞 No post yet 🌞
                                </div>
                            </>
                        ) : (
                            list.map((l) => (
                                <Listcard
                                    key={l.id}
                                    title={l.Title}
                                    description={l.Description}
                                    id={l.id}
                                    pressed={handleEdit}
                                    editF={editForm}
                                />
                            ))
                        )}
                    </div>
                </div>
            </div>
        </AppLayout>
    );
}
