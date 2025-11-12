import TodolistController from '@/actions/App/Http/Controllers/TodolistController';

import { Textarea } from '@headlessui/react';
import { Form } from '@inertiajs/react';
import { ArrowLeft, Loader2Icon } from 'lucide-react';
import { useEffect, useState } from 'react';
import InputError from './input-error';
import { Button } from './ui/button';
import { Input } from './ui/input';

export default function EditTodoform(props: {
    initialTitle: any;
    initialDescription: any;
    initialId: any;
    cancelEdit?: (val: boolean) => void;
}) {
    const { initialTitle, initialDescription, initialId, cancelEdit } = props;
    const [id, setId] = useState('');
    const [title, setTitle] = useState('');
    const [description, setDescription] = useState('');
    useEffect(() => {
        setId(initialId);
        setTitle(initialTitle);
        setDescription(initialDescription);
    }, [initialId, initialTitle, initialDescription]);

    return (
        <>
            <Form
                {...TodolistController.update.form(id)}
                resetOnSuccess={['title', 'description']}
                disableWhileProcessing
                className="flex flex-col justify-center gap-3"
            >
                {({ processing, errors }) => (
                    <>
                        <div className="flex flex-row justify-between">
                            <span className="font-bold">Edit Post</span>
                            <Button
                                className="cursor-pointer"
                                onClick={() => cancelEdit?.(false)}
                                variant="ghost"
                            >
                                <ArrowLeft className="inline-block h-4 w-4" />
                            </Button>
                        </div>
                        <div className="flex flex-col justify-center gap-2">
                            <span className="self-start text-[12px] text-gray-500">
                                Title
                            </span>
                            <Input
                                minLength={8}
                                type="text"
                                value={id}
                                onChange={(e) => setId(e.target.value)}
                                name="title"
                                hidden
                                required
                                className="rounded-3xl border bg-gray-200 p-2 text-[12px]"
                            />
                            <Input
                                minLength={1}
                                type="text"
                                value={title}
                                onChange={(e) => setTitle(e.target.value)}
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
                                value={description}
                                onChange={(e) => setDescription(e.target.value)}
                                required
                                id=""
                                className="max-h-90 min-h-50 rounded-3xl border bg-gray-200 p-2 text-[12px]"
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
        </>
    );
}
