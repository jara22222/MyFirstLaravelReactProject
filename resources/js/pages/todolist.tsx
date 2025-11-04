import TodolistController from '@/actions/App/Http/Controllers/TodolistController';
import InputError from '@/components/input-error';
import Listcard from '@/components/listcard';
import { Button } from '@/components/ui/button';
import AppLayout from '@/layouts/app-layout';
import { todolist } from '@/routes';
import { BreadcrumbItem } from '@/types';
import { Input, Textarea } from '@headlessui/react';
import { Form, Head, usePage } from '@inertiajs/react';
import { Loader2Icon } from 'lucide-react';
import { useEffect, useRef } from 'react';
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
        flash?: { success?: string; error?: string };
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

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Todolist" />
            <Toaster position="top-right" />
            <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                <div className="m:w-full grid items-start gap-2 sm:grid-cols-1 md:grid-cols-1 lg:grid-cols-2">
                    <Form
                        {...TodolistController.store.form()}
                        resetOnSuccess={['title', 'description']}
                        disableWhileProcessing
                        className="flex flex-col justify-center gap-3"
                    >
                        {({ processing, errors }) => (
                            <>
                                <div className="flex flex-col justify-center gap-2">
                                    <span className="self-start text-[12px] text-gray-500">
                                        Title
                                    </span>
                                    <Input
                                        minLength={8}
                                        type="text"
                                        name="title"
                                        required
                                        className="rounded-3xl border bg-gray-200 p-2 text-[12px]"
                                    />
                                    <InputError message={errors.title} />
                                </div>

                                <div className="flex flex-col justify-center gap-2">
                                    <span className="self-start text-[12px] text-gray-500">
                                        Description
                                    </span>
                                    <Textarea
                                        maxLength={1500}
                                        name="description"
                                        required
                                        id=""
                                        className="max-h-100 min-h-50 rounded-3xl border bg-gray-200 p-2 text-[12px]"
                                    ></Textarea>
                                </div>
                                <div className="flex flex-col justify-center">
                                    <Button
                                        disabled={processing}
                                        type="submit"
                                        className="cursor-pointer rounded-3xl"
                                    >
                                        {processing ? (
                                            <Loader2Icon className="animate-spin" />
                                        ) : (
                                            'Create List'
                                        )}
                                    </Button>
                                </div>
                            </>
                        )}
                    </Form>
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
                                />
                            ))
                        )}
                    </div>
                </div>
            </div>
        </AppLayout>
    );
}
