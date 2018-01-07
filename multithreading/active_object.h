#ifndef ACTIVE_OBJECT_H
#define ACTIVE_OBJECT_H

#include <pthread.h>


class ActiveObject
{
public:

   ActiveObject() {}
   virtual ~ActiveObject() {}

   bool start()
   {
      return (pthread_create(&m_thread, NULL, _run, this) == 0);
   }

   void exit()
   {
      (void)pthread_join(m_thread, NULL);
   }

protected:
   virtual void run() = 0;

private:
   static void * _run(void *p) {((ActiveObject *)p)->run(); return NULL;}

   pthread_t m_thread;
};

#endif // ACTIVE_OBJECT_H

